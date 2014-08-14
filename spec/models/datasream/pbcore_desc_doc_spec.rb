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
  end
end
