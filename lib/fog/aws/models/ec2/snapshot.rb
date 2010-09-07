require 'fog/model'

module Fog
  module AWS
    class EC2

      class Snapshot < Fog::Model
        extend Fog::Deprecation
        deprecate(:status, :state)

        identity  :id,          :aliases => 'snapshotId'

        attribute :description
        attribute :progress
        attribute :created_at,  :aliases => 'startTime'
        attribute :owner_id,    :aliases => 'ownerId'
        attribute :state,       :aliases => 'status'
        attribute :volume_id,   :aliases => 'volumeId'
        attribute :volume_size, :aliases => 'volumeSize'

        def destroy
          requires :id

          connection.delete_snapshot(@id)
          true
        end

        def ready?
          state == 'completed'
        end

        def save
          requires :volume_id

          data = connection.create_snapshot(@volume_id, @description).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end

        def volume
          requires :id

          connection.describe_volumes(@volume_id)
        end

        private

        def volume=(new_volume)
          @volume_id = new_volume.volume_id
        end

      end

    end
  end
end
