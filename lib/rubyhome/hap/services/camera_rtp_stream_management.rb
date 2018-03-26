# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class CameraRTPStreamManagement < Service
      class << self
        def uuid
          "00000110-0000-1000-8000-0026BB765291"
        end

        def name
          :camera_rtp_stream_management
        end

        def required_characteristic_uuids
          ["00000114-0000-1000-8000-0026BB765291", "00000115-0000-1000-8000-0026BB765291", "00000116-0000-1000-8000-0026BB765291", "00000117-0000-1000-8000-0026BB765291", "00000120-0000-1000-8000-0026BB765291", "00000118-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Camera RTP Stream Management"
      end
    end
  end
end
