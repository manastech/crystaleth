require "spec"
require "../../src/models/account"
require "../../src/common/constants"
require "../../src/common/types"

describe Pampero::Account do
  it "contracts" do
    tests = [
      {code_hash: nil,
       expected:  false},
      {code_hash: Pampero::KECCAK256_NULL_S,
       expected:  false},
      {code_hash: "0xeebb876505b51d8a9ab7ad18da64f595287d0da1d9d919dbc3af08e6a94ff89e",
       expected:  true},
    ]

    tests.each do |t|
      code_hash = t[:code_hash]
      code_hash = Pampero::Bytes32.new(code_hash) if code_hash
      account = Pampero::Account.new(code_hash: code_hash)

      result = account.contract?

      result.should eq(t[:expected])
    end
  end
end
