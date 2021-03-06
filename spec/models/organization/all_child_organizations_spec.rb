require "rails_helper"

RSpec.describe Organization, type: :model do

  describe ".all_child_organizations" do

    context "child Organizations present" do

      it "should return an array of child Organizations" do
        organization = create(:organization_with_child_organizations)

        expect(organization.all_child_organizations.length).to eq(12)
      end
    end

    context "child Organizations not present" do

      it "should return an empty array" do
        organization = create(:organization)

        expect(organization.all_child_organizations).to eq([])
      end
    end
  end
end
