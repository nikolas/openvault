require 'spec_helper'

describe PbcoreDescDoc do
  describe 'factory' do
    it 'can build a PbcoreDescDoc' do
      expect(build(:pbcore_desc_doc)).to be_a PbcoreDescDoc
    end

    context 'when using the :all_ids option' do
      it 'builds a PbcoreDescDoc with pbcoreIdentifier nodes having those values' do
        pb = build(:pbcore_desc_doc, all_ids: ['123', '456'])
        expect(pb.all_ids(0)).to eq ['123']
        expect(pb.all_ids(1)).to eq ['456']
      end
    end

    context 'when :with_artesia_id trait is used' do
      it 'has a sample UOI_ID' do
        pb = build(:pbcore_desc_doc, :with_artesia_id)
        expect(pb.ids_by_source['UOI_ID']).to_not be_nil
      end
    end

    context 'with the :with_mars_asset_id trait' do
      it 'has a sample MARS id as if it came from the "assets" table from MARS database' do
        pb = build(:pbcore_desc_doc, :with_mars_asset_id)
        expect(pb.ids_by_source['MARS Asset Record ID']).to_not be_nil
      end
    end

    context 'with the :with_mars_program_id trait' do
      it 'has a sample MARS id as if it came from the "programs" table from MARS database' do
        pb = build(:pbcore_desc_doc, :with_mars_program_id)
        expect(pb.ids_by_source['MARS Program Record ID']).to_not be_nil
      end
    end

    context 'with the :with_date_portrayed trait' do
      it 'has a pbcoreCoverage coverage with ref=DATE_PORTRAYED' do
        pb = build(:pbcore_desc_doc, :with_date_portrayed)
        expect(pb.coverage.date_portrayed).to_not be_nil
      end
    end

    context 'when using the :ids_with_sources option' do
      context 'as a single array of the form ["123", "foo"]' do
        it 'builds a PbcoreDescDoc with a pbcoreIdentifier node, having a value of "123", and attribute source="foo"' do
          pb = build(:pbcore_desc_doc, ids_with_sources: ['123', 'foo'])
          expect(pb.all_ids.count).to eq 1
          expect(pb.all_ids(0)).to eq ['123']
          expect(pb.all_ids(0).source).to eq ['foo']
        end
      end

      context 'as an array of arrays, each having the form ["123", "foo"]' do
        it 'builds a PbcoreDescDoc with multiple pbcoreIdnetifier nodes, each taking their values from the first elements, and the values of their "source" attributes from the 2nd elements.' do
          pb = build(:pbcore_desc_doc, ids_with_sources: [['123', 'foo'], ['456', 'bar']])
          expect(pb.all_ids.count).to eq 2
          expect(pb.all_ids(0)).to eq ['123']
          expect(pb.all_ids(0).source).to eq ['foo']
          expect(pb.all_ids(1)).to eq ['456']
          expect(pb.all_ids(1).source).to eq ['bar']
        end
      end

    end

    context 'using the `relations:` option' do
      context 'with a numeric value, eg `relations: 2`' do
        it 'builds a PbcoreDescDoc with 2 <pbcoreRelation> nodes, each of which contain a pbcoreRelationType and pbcoreRelationId conataining arbitrary data.' do
          pb = build(:pbcore_desc_doc, relations: 2)

          # has exactly 2 relations
          expect(pb.relations.count).to eq 2

          # :id and :type return an array of 1 element
          expect(pb.relations(0).id[0]).not_to be_nil
          expect(pb.relations(1).type[0]).not_to be_nil
        end
      end

      context 'with an array of hashes, e.g. `relations: [{id: "123", type: "foo"}, {id: "456", type: "bar"}]`' do
        it 'builds a PbcoreDescDoc with 2 relations, each with pbcoreRelationType and pbcoreRelationId containing the given values' do
          pb = build(:pbcore_desc_doc, relations: [{id: '123', type: 'foo'}, {id: '456', type: 'bar'}])
          # has exactly 2 relations
          expect(pb.relations.count).to eq 2

          # first relation has specified values
          expect(pb.relations(0).id).to eq ['123']
          expect(pb.relations(0).type).to eq ['foo']

          # second relation has specified values
          expect(pb.relations(1).id).to eq ['456']
          expect(pb.relations(1).type).to eq ['bar']
        end
      end
    end
  end
end
