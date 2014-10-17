require 'spec_helper'

describe Series do
  it 'has a valid factory' do
    expect(create(:series)).to be_a Series
  end

  let(:series) { Series.new }

  describe "#thumbnail_url" do
    context "has image directly related to it" do
      it "returns url of first image" do
        allow(series).to receive(:images) do
          [double(image_url: "series_image.gif")]
        end
        expect(series.thumbnail_url).to eq "series_image.gif"
      end
    end

    context "has no associated programs, videos, or images" do
      it "returns nil" do
        allow(series).to receive(:images) { [] }
        expect(series.thumbnail_url).to eq nil
      end
    end
  end

  describe "#thumbnail_url_fallback" do
    context "has a program with value for its thumbnail_url" do
      it "returns url of thumbnail of that program" do
        allow(series).to receive(:programs) do
          [double(thumbnail_url: "program_image.gif")]
        end
        expect(series.thumbnail_url_fallback).to eq "program_image.gif"
      end
     
      context "and does not have any programs related to it" do
        context "but does have a video with value for its thumbnail_url" do
          it "returns url of thumbnail of that video" do
            allow(series).to receive(:videos) do
              [double(thumbnail_url: "video_image.gif")]
            end
            expect(series.thumbnail_url_fallback).to eq "video_image.gif"
          end
        end 
      
        context "and does not have any video related to it" do
          it "returns nil" do
            allow(series).to receive(:videos) { [] }
            expect(series.thumbnail_url_fallback).to eq nil
          end
        end
      end
    end
  end
end
