module GibbonHelper
  # Gibbon call chain: Gibbon::Request.lists(mailing_list_id).members(email)
  def stub_gibbon_members(api_key, mailing_list_id, email)
    gibbon_client = double('gibbon_client')
    lists = double('lists')
    members = double('members')

    expect(Gibbon::Request).to receive(:new).with(api_key: api_key).and_return(gibbon_client)
    expect(gibbon_client).to receive(:lists).with(mailing_list_id).and_return(lists)
    expect(lists).to receive(:members).with(Digest::MD5.hexdigest(email)).and_return(members)
    members
  end
end
