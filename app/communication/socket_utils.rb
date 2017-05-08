require 'zlib'
require 'json'
require 'socket'
require 'timeout'

module YugiohX2
  class SocketUtils
    HEADER = [Zlib.adler32('yugiohx2-header'.encode('ASCII-8BIT'))].pack('N')
    FOOTER = [Zlib.adler32('yugiohx2-footer'.encode('ASCII-8BIT'))].pack('N')

    class << self
      def ensure_close(socket)
        if !socket.nil? && !socket.closed?
          socket.close
        end
      end

      def informed_ensure_close(socket)
        if !socket.nil? && !socket.closed?
          begin
            SocketUtils.write(socket, {message: "Closing the connection"})
          rescue Errno::EPIPE => e
            SLogger.instance.debug("couldn't inform client of connection end")
          ensure
            socket.close
          end
        end
      end

      def write(socket, hash)
        header = HEADER.dup
        footer = FOOTER.dup
        json = hash.to_json

        message = header + [json.bytesize].pack("N") + json + footer
        SLogger.instance.debug("Writing message #{message.bytesize} bytes")
        socket.write(message)
      end

      #TODO : read needs to read everything
      def read(socket, timeout)
        header = read_bytes(socket, 4, timeout)
        raise "Incorrect Header" unless header == HEADER
        json_bytesize =  read_bytes(socket, 4, timeout).unpack("N").first
        json =  read_bytes(socket, json_bytesize, timeout)
        footer = read_bytes(socket, 4, timeout)
        raise "Incorrect Footer" unless footer == FOOTER
        message = JSON.parse(json)
        SLogger.instance.debug("received message: #{message}")
        message
      end

      private
      def read_bytes(socket, bytes, timeout)
        t0 = Time.now
        begin
          time_remaining = t0 + timeout - Time.now
          wait_for_socket_readable(socket, time_remaining)
          until (socket.recv_nonblock(bytes, Socket::MSG_PEEK).bytesize == bytes) do
            validate_timeout(t0, timeout)
            SLogger.instance.debug("Waiting for input...")
            sleep(1)
          end
          bytes = socket.recv_nonblock(bytes)
          SLogger.instance.debug("Received message #{bytes.bytesize} bytes")
          bytes
        rescue Errno::EAGAIN
          validate_timeout(t0, timeout)
          retry
        end
      end

      def wait_for_socket_readable(socket, timeout)
        read_sockets = [socket]
        write_sockets = []
        error_sockets = []
        SLogger.instance.debug("Waiting for socket to be in readable state...")
        ready_read, ready_write, ready_error = IO.select(read_sockets, write_sockets, error_sockets, timeout)

        if !ready_read.nil? && ready_read.include?(socket)
          return
        else
          SLogger.instance.error("Timed out waiting for socket to become readable")
          raise Timeout::Error
        end
      end

      def validate_timeout(t0, timeout_seconds)
        if (Time.now - t0) >= timeout_seconds
          SLogger.instance.error("Timeout, exceeded #{timeout_seconds}s")
          raise Timeout::Error.new("Timeout, exceeded #{timeout_seconds}s")
        end
      end
    end
  end
end
