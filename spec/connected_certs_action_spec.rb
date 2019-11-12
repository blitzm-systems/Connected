describe Fastlane::Actions::ConnectedAuthAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to(
        receive(:success)
        .exactly(2)
      )

      Fastlane::FastFile.new.parse("
        lane :certs_test do
          connected_certs(
            app_id: '*',
          )
        end").runner.execute(:certs_test)
    end
  end
end
