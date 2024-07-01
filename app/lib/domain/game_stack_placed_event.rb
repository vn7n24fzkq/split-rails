module Domain
  class GameStackPlacedEvent < Event
    def initialize(game_id: nil)
      raise 'game_id is required' if game_id.nil?

      super(game_id:)
    end

    def event_type
      'stack_placed'.freeze
    end

    def dispatch
      Game.find(params[:game_id])
          .then do |game|
        GameChannel.broadcast_to(
          game, {
            event: event_type,
            game_config: game.game_config,
            game_data: game.game_data,
            action: game.action
          }
        )
      end
    end
  end
end
