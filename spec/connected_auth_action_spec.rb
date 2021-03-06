describe Fastlane::Actions::ConnectedAuthAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to(
        receive(:success)
        .exactly(2)
      )

      Fastlane::FastFile.new.parse("
        lane :auth_test do
          connected_auth(
            api_key: '*',
            key_id: '*',
            issuer_id: '*'
          )
        end").runner.execute(:auth_test)
    end
  end
end
