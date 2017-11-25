require "openssl"

module Rubyhome
  module SRP
    class << self

      def sha1_hex(h)
        OpenSSL::Digest::SHA512.hexdigest([h].pack('H*'))
      end

      def sha1_str(s)
        OpenSSL::Digest::SHA512.hexdigest(s)
      end

      def bigrand(bytes)
        OpenSSL::Random.random_bytes(bytes).unpack("H*")[0]
      end

      # a^n (mod m)
      def modpow(a, n, m)
        r = 1
        while true
          r = r * a % m if n[0] == 1
          n >>= 1
          return r if n == 0
          a = a * a % m
        end
      end

      # SHA1 hashing function with padding.
      # Input is prefixed with 0 to meet N hex width.
      def H(n, *a)
        nlen = 2 * ((('%x' % [n]).length * 4 + 7) >> 3)
        hashin = a.map {|s|
          next unless s
          shex = s.class == String ? s : "%x" % s
          if shex.length > nlen
              raise "Bit width does not match - client uses different prime"
          end
          "0" * (nlen - shex.length) + shex
        }.join('')
        sha1_hex(hashin).hex % n
      end

      # Multiplier parameter
      # k = H(N, g)   (in SRP-6a)
      def calc_k(n, g)
        H(n, n, g)
      end

      # Private key (derived from username, raw password and salt)
      # x = H(salt || H(username || ':' || password))
      def calc_x(username, password, salt)
        spad = if salt.length.odd? then '0' else '' end
        sha1_hex(spad + salt + sha1_str([username, password].join(':'))).hex
      end

      # Random scrambling parameter
      # u = H(A, B)
      def calc_u(xaa, xbb, n)
        H(n, xaa, xbb)
      end

      # Password verifier
      # v = g^x (mod N)
      def calc_v(x, n, g)
        modpow(g, x, n)
      end

      # A = g^a (mod N)
      def calc_A(a, n, g)
        modpow(g, a, n)
      end

      # B = g^b + k v (mod N)
      def calc_B(b, k, v, n, g)
        (modpow(g, b, n) + k * v) % n
      end

      # Client secret
      # S = (B - (k * g^x)) ^ (a + (u * x)) % N
      def calc_client_S(bb, a, k, x, u, n, g)
        modpow((bb - k * modpow(g, x, n)) % n, (a+ x * u), n)
      end

      # Server secret
      # S = (A * v^u) ^ b % N
      def calc_server_S(aa, b, v, u, n)
        modpow((modpow(v, u, n) * aa), b, n)
      end

      # M = H(H(N) xor H(g), H(I), s, A, B, K)
      def calc_M(username, xsalt, xaa, xbb, xkk, n, g)
        hn = sha1_hex("%x" % n).hex
        hg = sha1_hex("%x" % g).hex
        hxor = "%x" % (hn ^ hg)
        hi = sha1_str(username)
        return H(n, hxor, hi, xsalt, xaa, xbb, xkk)
      end

      # H(A, M, K)
      def calc_H_AMK(xaa, xmm, xkk, n, g)
        H(n, xaa, xmm, xkk)
      end

      def Ng(group)
        case group
        when 3072
          @N = %w{
            FFFFFFFF FFFFFFFF C90FDAA2 2168C234 C4C6628B 80DC1CD1 29024E08
            8A67CC74 020BBEA6 3B139B22 514A0879 8E3404DD EF9519B3 CD3A431B
            302B0A6D F25F1437 4FE1356D 6D51C245 E485B576 625E7EC6 F44C42E9
            A637ED6B 0BFF5CB6 F406B7ED EE386BFB 5A899FA5 AE9F2411 7C4B1FE6
            49286651 ECE45B3D C2007CB8 A163BF05 98DA4836 1C55D39A 69163FA8
            FD24CF5F 83655D23 DCA3AD96 1C62F356 208552BB 9ED52907 7096966D
            670C354E 4ABC9804 F1746C08 CA18217C 32905E46 2E36CE3B E39E772C
            180E8603 9B2783A2 EC07A28F B5C55DF0 6F4C52C9 DE2BCBF6 95581718
            3995497C EA956AE5 15D22618 98FA0510 15728E5A 8AAAC42D AD33170D
            04507A33 A85521AB DF1CBA64 ECFB8504 58DBEF0A 8AEA7157 5D060C7D
            B3970F85 A6E1E4C7 ABF5AE8C DB0933D7 1E8C94E0 4A25619D CEE3D226
            1AD2EE6B F12FFA06 D98A0864 D8760273 3EC86A64 521F2B18 177B200C
            BBE11757 7A615D6C 770988C0 BAD946E2 08E24FA0 74E5AB31 43DB5BFC
            E0FD108E 4B82D120 A93AD2CA FFFFFFFF FFFFFFFF
          }.join.hex
          @g = 5
        else
          raise NotImplementedError
        end
        return [@N, @g]
      end
    end


    class Verifier
      attr_reader :N, :g, :k, :A, :B, :b, :S, :K, :M, :H_AMK

      def initialize group=3072
        # select modulus (N) and generator (g)
        @N, @g = SRP.Ng group
        @k = SRP.calc_k(@N, @g)
      end

      # Initial user creation for the persistance layer.
      # Not part of the authentication process.
      # Returns { <username>, <password verifier>, <salt> }
      def generate_userauth username, password
        @salt ||= random_salt
        x = SRP.calc_x(username, password, @salt)
        v = SRP.calc_v(x, @N, @g)
        return {:username => username, :verifier => "%x" % v, :salt => @salt}
      end

      # Authentication phase 1 - create challenge.
      # Returns Hash with challenge for client and proof to be stored on server.
      # Parameters should be given in hex.
      def get_challenge_and_proof username, xverifier, xsalt, xaa
        # SRP-6a safety check
        return false if (xaa.to_i(16) % @N) == 0
        generate_B(xverifier)
        return {
          :challenge    => {:B => @B, :salt => xsalt},
          :proof        => {:A => xaa, :B => @B, :b => "%x" % @b,
                            :I => username, :s => xsalt, :v => xverifier}
        }
      end

      # returns H_AMK on success, None on failure
      # User -> Host:  M = H(H(N) xor H(g), H(I), s, A, B, K)
      # Host -> User:  H(A, M, K)
      def verify_session proof, client_M
        @A = proof[:A]
        @B = proof[:B]
        @b = proof[:b].to_i(16)
        username = proof[:I]
        xsalt = proof[:s]
        v = proof[:v].to_i(16)

        u = SRP.calc_u(@A, @B, @N)
        # SRP-6a safety check
        return false if u == 0

        # calculate session key
        @S = "%x" % SRP.calc_server_S(@A.to_i(16), @b, v, u, @N)
        @K = SRP.sha1_hex(@S)

        # calculate match
        @M = "%x" % SRP.calc_M(username, xsalt, @A, @B, @K, @N, @g)

        if @M == client_M
          # authentication succeeded
          @H_AMK = "%x" % SRP.calc_H_AMK(@A, @M, @K, @N, @g)
          return @H_AMK
        end
        return false
      end

      def random_salt
        "%x" % SRP.bigrand(16).hex
      end

      def random_bignum
        SRP.bigrand(32).hex
      end

      # generates challenge
      # input verifier in hex
      def generate_B xverifier
        v = xverifier.to_i(16)
        @b ||= random_bignum
        @B = "%x" % SRP.calc_B(@b, k, v, @N, @g)
      end
    end
  end
end
