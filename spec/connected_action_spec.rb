describe Fastlane::Actions::ConnectedAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The connected plugin is working!")

      Fastlane::Actions::ConnectedAction.run(nil)
    end
  end
end
