require 'spec_helper'

describe Program do

  let(:program) { Program.new }

  describe "#thumbnail_url" do
    context "has image directly related to it" do
      it "returns url of first image" do
        allow(program).to receive(:images) do
          [double(image_url: "program_image.gif")]
        end
        expect(program.thumbnail_url).to eq "program_image.gif"
      end
    end

    context "has no associated series, videos, audios, or images" do
      it "returns nil" do
        allow(program).to receive(:images) { [] }
        expect(program.thumbnail_url).to eq nil
      end
    end
  end

  describe "#thumbnail_url_fallback" do
    context "has a video with value for its thumbnail_url" do
      it "returns url of thumbnail of that video" do
        allow(program).to receive(:videos) do
          [double(thumbnail_url: "video_image.gif")]
        end
        expect(program.thumbnail_url_fallback).to eq "video_image.gif"
      end

      context "and does not have any videos related to it" do
        context "but does have an audio with value for its thumbnail_url" do
          it "returns url of thumbnail of that audio" do
            allow(program).to receive(:audios) do
              [double(thumbnail_url: "audio_image.gif")]
            end
            expect(program.thumbnail_url_fallback).to eq "audio_image.gif"
          end
        end

        context "and does not have any audio related to it" do
          context "but does belong to a series with value for its thumbnail_url" do
            it "returns url of thumbnail of that series" do
              allow(program).to receive(:series) do
                double(thumbnail_url: "series_image.gif")
              end
              expect(program.thumbnail_url_fallback).to eq "series_image.gif"
            end
          end

          context "and does not have any series related to it" do
            it "returns nil" do
              allow(program).to receive(:series) { nil }
              expect(program.thumbnail_url_fallback).to eq nil
            end
          end
        end
      end
    end
  end
end
