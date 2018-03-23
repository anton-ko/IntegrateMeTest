require "rails_helper"

describe Competition do
  it "should require a name" do
    expect { Competition.create!(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  describe '.subscribes_to_mailing_list?' do
    context 'when mailchimp key and mailing list id present' do
      subject { Competition.new(account: build(:account, :with_mailchimp), mailing_list_id: 1234) }
      it { expect(subject.subscribes_to_mailing_list?).to be_truthy }
    end

    context 'when mailchimp key is present but mailing list is not' do
      subject { Competition.new(account: build(:account, :with_mailchimp)) }
      it { expect(subject.subscribes_to_mailing_list?).to be_falsey }
    end

    context 'when mailchimp key is missing but mailing list id is present' do
      subject { Competition.new(account: build(:account), mailing_list_id: 1234) }
      it { expect(subject.subscribes_to_mailing_list?).to be_falsey }
    end

    context 'when both mailchimp key and mailing list id are missing' do
      subject { Competition.new(account: build(:account)) }
      it { expect(subject.subscribes_to_mailing_list?).to be_falsey }
    end
  end
end
