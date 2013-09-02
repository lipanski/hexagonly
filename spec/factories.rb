require 'csv'

FactoryGirl.define do
  localities_csv = CSV.read(File.expand_path('../fixtures/localities.csv', __FILE__))

  factory :point, :class => HexagonalTiling::Point do
    sequence(:x) do |n|
      localities_csv.size >= n ? localities_csv[n][2] : nil
    end
    sequence(:y) do |n|
      localities_csv.size >= n ? localities_csv[n][1] : nil
    end
    initialize_with { new(x, y) }
  end
end