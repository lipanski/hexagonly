require 'csv'

FactoryGirl.define do
  localities_csv = CSV.read(File.expand_path('../fixtures/localities.csv', __FILE__))

  sequence(:x) { |n| localities_csv.size >= n ? localities_csv[n][2].to_f : nil }
  sequence(:y) { |n| localities_csv.size >= n ? localities_csv[n][1].to_f : nil }

  factory :point, :class => Hexagonly::Point do
    initialize_with { new(generate(:x), generate(:y)) }
  end
end