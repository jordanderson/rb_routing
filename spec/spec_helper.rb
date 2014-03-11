require 'rspec'
require 'rb_routing'
require 'debugger'

$database  = ENV.has_key?("RB_ROUTING_TEST_DB")        ? ENV['RB_ROUTING_TEST_DB']       : "rb_routing_test"
$host      = ENV.has_key?("RB_ROUTING_TEST_HOST")      ? ENV['RB_ROUTING_TEST_HOST']     : "localhost"
$port      = ENV.has_key?("RB_ROUTING_TEST_PORT")      ? ENV['RB_ROUTING_TEST_PORT']     : "6969"
$user      = ENV.has_key?("RB_ROUTING_TEST_USER")      ? ENV['RB_ROUTING_TEST_USER']     : "postgres"
$password  = ENV.has_key?("RB_ROUTING_TEST_PASSWORD")  ? ENV['RB_ROUTING_TEST_PASSWORD'] : "postgres"
ENV["PGPASSWORD"] = $password

test_db_path = File.join(File.dirname(File.expand_path(__FILE__)), '/fixtures/test_database.sql')
puts "Creating database #{$database} for testing"
`psql -c 'drop database if exists #{$database};' -U #{$user} -h #{$host} -p #{$port}`
`psql -c 'create database #{$database};' -U #{$user} -h #{$host} -p #{$port}`
`psql -c 'CREATE EXTENSION postgis; CREATE EXTENSION pgrouting;' -d #{$database} -U #{$user} -h #{$host} -p #{$port}`
`psql -f #{test_db_path} -d #{$database} -U #{$user} -h #{$host} -p #{$port}` 