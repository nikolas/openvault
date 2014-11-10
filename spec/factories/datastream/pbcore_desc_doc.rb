require 'factory_girl'
require 'faker'
require 'artesia'
require 'mars'

FactoryGirl.define do

  factory :pbcore_desc_doc do

    skip_create

    trait :with_artesia_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [Artesia::ID.generate]
        pb.all_ids(pb.all_ids.count-1).source = 'UOI_ID'
      end
    end

    trait :with_mars_asset_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [MARS::ID.generate('A_')]
        pb.all_ids(pb.all_ids.count - 1).source = 'MARS Asset Record ID'
      end
    end

    trait :with_mars_program_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [MARS::ID.generate('P_')]
        pb.all_ids(pb.all_ids.count - 1).source = 'MARS Program Record ID'
      end
    end

    trait :with_series_title do
      series_title do
        t = [
          "#{Faker::Hacker.adjective} #{Faker::Hacker.noun}",
          "#{Faker::Hacker.ingverb} in #{Faker::Address.city}",
          "#{Faker::Hacker.ingverb} in #{Faker::Commerce.color}",
          "#{Faker::Hacker.ingverb} #{Faker::Hacker.noun.pluralize} with #{Faker::Name.name}",
          "#{Faker::Hacker.noun}",
          "#{Faker::Hacker.noun.pluralize}",
          ].sample

        t += " with #{Faker::Name.name}" if (rand(5) % 5) == 0

        t.titleize
      end
    end

    trait :with_program_title do
      program_title do
        t = [
            "#{Faker::Commerce.department}",
          "#{Faker::Hacker.ingverb} the #{[Faker::Hacker.adjective, Faker::Commerce.color].sample} #{Faker::Hacker.noun}",
          "#{Faker::Name.name}",
          "#{Faker::Name.name} goes #{Faker::Hacker.ingverb} with #{Faker::Name.name}",
          "#{Faker::Hacker.noun}",
          "#{Faker::Hacker.noun.pluralize}",
          "#{[Faker::Hacker.adjective + ' ', ''].sample}#{Faker::Commerce.product_name.pluralize} of #{Faker::Address.city}",
          ].sample

        t.titleize
      end
    end
    
    trait :with_date_portrayed do
      after(:build) do |pbcore, evaluator|
        pbcore.coverage.date_portrayed = "4/15/1970"
      end
    end


    ignore do

      ids nil

      ids_with_sources nil

      # See the after(:build) section below that checks for evaluator.relations on how to build a PbcoreDescDoc with some relations.
      relations nil
    end

    after(:build) do |pbcore, evaluator|

      if !!evaluator.ids
        Array(evaluator.ids).each do |id|
          raise ArgumentError ":ids options must be a string, or an array of strings. #{id.type} was given." unless id.respond_to? :to_s
          pbcore.all_ids += Array(id.to_s)
        end
      end

      # :ids_with_sources option takes one of the following forms:
      #
      #   A single array, with ID and attributes
      #   ['123', 'value for source']
      # 
      #   Multiple arrays, each with an ID and attributes
      #   [['123', 'value for source'], ['456', 'value for source']]
      # 
      #   NOTE: Mysterious errors may occur if the params aren't of one of these formats.
      if !!evaluator.ids_with_sources

        @ids_with_sources = evaluator.ids_with_sources
        @ids_with_sources = [@ids_with_sources] unless @ids_with_sources.first.respond_to?(:each)

        # Ensure it's an array when iterating...
        @ids_with_sources.each do |id_and_source|

          # Ensure each element is also an array
          id_and_source = Array(id_and_source)

          # fist element is the id, second element is the source
          id, source = id_and_source[0], id_and_source[1]

          # Add the ID.
          pbcore.all_ids += Array(id)
          
          # Add the source
          last_id_index = pbcore.all_ids.count - 1
          pbcore.all_ids(last_id_index).source += Array(source)
        end
      end
      
      # Adding pbcore relations:
      #   The following will build PbcoreDescDoc with 2 relations, random data:
      #
      #     build(:pbcore_desc_doc, relations: 2)
      # 
      #   The following will build a PbcoreDescDoc with 2 relations, each having the specified :type and :id values for the pbcoreRelationType and pbcoreRelationId nodes, respectively.
      # 
      #     build(:pbcore_desc_doc, relations: [{id: '123', type: 'some type'}, {id: '456', type: 'another type'}])
      # 
      if !!evaluator.relations

        relations = []
        if evaluator.relations.respond_to? :to_i
          evaluator.relations.to_i.times do
            relations << {}
          end
        else
          relations = evaluator.relations
        end

        for i in 0...(relations.count) do
          pbcore.relations(i).id = relations[i][:id] || Artesia::ID.generate
          pbcore.relations(i).type = relations[i][:type] || 'SAMPLE PBCORE RELATION TYPE'
        end
      end

    end
  end
end