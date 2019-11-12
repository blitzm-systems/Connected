describe Fastlane::Actions::ConnectedAuthAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to(
        receive(:success)
        .exactly(2)
      )

      Fastlane::FastFile.new.parse("
        lane :upload_test do
          connected_upload(
            ipa_file: '*',
          )
        end").runner.execute(:upload_test)
    end
  end
end
