class DhlTrackingApi
  class Response
    # extend ActiveSupport::Memoizable
    attr_reader :raw_response

    def initialize(api_wrapper)
      @api_wrapper  = api_wrapper
      @raw_response = @api_wrapper.response
    end

    def error_message
      @api_wrapper.error_message || response_doc.css('data').first['error'] || piece_shipment_list_element['error']
    end

    def errors?
      !error_message.nil?
    end

    def picked_up?
      piece_events.any?(&:picked_up?)
    end

    def delivered?
      piece_events.any?(&:delivered?)
    end

    def scan_in_inbound_packet_central?
      piece_events.any?(&:scan_in_inbound_packet_central?)
    end
    alias :shipped? :scan_in_inbound_packet_central?

    def response_body
      @api_wrapper.response.body
      # DhlTrackingApi::DemoResponse
    end

    def response_doc
      Nokogiri.parse(response_body)
    end
    # memoize :response_body

    def piece_shipment
      Response::PieceShipment.new(piece_shipment_element)
    end
    # memoize :piece_shipment

    def piece_events
      piece_event_elements.map do |piece_event_element|
        Response::PieceEvent.new(piece_event_element)
      end
    end
    # memoize :piece_events

    def piece_shipment_list_element
      response_doc.css('data[name="piece-shipment-list"]').first
    end
    # memoize :piece_shipment_list_element

    def piece_shipment_element
      response_doc.css('data[name="piece-shipment"]').sort do |first, second|
        second['piece-id'] <=> first['piece-id']
        # second['status-timestamp'] <=> first['status-timestamp']
      end.first
    end
    # memoize :piece_shipment_element

    def piece_event_elements
      if piece_shipment_list_element
        piece_shipment_element.css('data[name="piece-event-list"] *')
      else
        []
      end
    end
    # memoize :piece_event_elements



    module Common
      def initialize(element)
        @element = element
      end

      def inspect
        to_hash.inspect
      end

      def delivered?
        ice == 'DLVRD'
      end

      def picked_up?
        ice == 'PCKDU'
      end

      def scan_in_inbound_packet_central?
        standard_event_code == 'AA' || standard_event_code == 'EE' || standard_event_code == 'ES'
      end

      def self.included(base)
        base.class_eval do
          self::RespondMethods.each do |method|
            resp_method = method.to_s.gsub('_', '-') #.dasherize
            define_method(method) { @element[resp_method] }
          end

          def to_hash
            {}.tap do |res|
              self.class::RespondMethods.each { |method| res[method] = @element[method.to_s.dasherize] }
            end
          end
        end
      end
    end


    class PieceShipment
      RespondMethods = [
        :ice, :name, :recipient_id_text, :recipient_street, :shipper_address,
        :status_timestamp, :data, :ric, :short_status, :searched_piece_code, :shipper_city, :standard_event_code,
        :shipper_name, :dest_country, :shipper_street, :piece_id, :pan_recipient_address, :pan_recipient_street,
        :division, :status_liste, :recipient_id, :piece_code, :event_location, :product_name, :international_flag,
        :origin_country, :identifier_type, :piece_identifier, :product_key, :event_country, :error_status, :product_code,
        :shipment_code, :piece_customer_reference, :status, :recipient_city, :recipient_name, :delivery_event_flag,
        :pan_recipient_city, :pan_recipient_name
      ]
      include Common
    end


    class PieceEvent
      RespondMethods = [
        :ice, :name, :ric, :event_text, :event_country,
        :standard_event_code, :event_status, :event_timestamp, :event_location
      ]
      include Common
    end

  end
end


