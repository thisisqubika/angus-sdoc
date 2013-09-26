module JsonRepresentations
  module Messages

    def message_representation(message)
      {
        :key => message.key,
        :description => message.description,
        :level => message.level,
        :status_code => message.status_code
      }
    end

  end
end