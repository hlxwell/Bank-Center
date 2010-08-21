class BankCenterGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "test.txt", "test.txt"
      # m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "bank_center_on_migration"
    end
  end
end