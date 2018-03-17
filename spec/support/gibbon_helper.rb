module GibbonHelper
  # Gibbon call chain: Gibbon::Request.lists(mailing_list_id).members(email)
  def stub_gibbon_members(mailing_list_id, email)
    lists = double('lists')
    members = double('members')

    expect(Gibbon::Request).to receive(:lists).with(mailing_list_id).and_return(lists)
    expect(lists).to receive(:members).with(Digest::MD5.hexdigest(email)).and_return(members)
    members
  end
end
