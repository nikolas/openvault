require 'spec_helper'

describe PbcoreDescDoc do
  describe 'factory' do
    it 'can build a PbcoreDescDoc' do
      expect(build(:pbcore_desc_doc)).to be_a PbcoreDescDoc
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
