require 'sequel'

Sequel.migration do
  up do
    create_table(:robot) do
      primary_key :id
      String :name, :null => false
      Integer :user_id, :null => false
      String :location, :null => false
      String :api_key, :null => false
      Timestamp :created_at
      Timestamp :updated_at
    end
  end

  down do
    drop_table(:robot)
  end
end
