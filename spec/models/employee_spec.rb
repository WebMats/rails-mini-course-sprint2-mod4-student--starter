require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "validations" do
    it "should affirm that employee is valid" do
      valid_employee = Employee.new(first_name: "John", last_name: "Doe", rewards_balance: 100)

      expect(valid_employee.valid?).to be true
    end

    it "should affirm that employee is invalid without a first name" do
      employee_without_first_name = Employee.new(first_name: nil, last_name: "Doe", rewards_balance: 200)

      expect(employee_without_first_name.valid?).to be false
    end

    it "should affirm that employee is invalid without a last name" do 
      employee_without_last_name = Employee.new(first_name: "Jane", last_name: nil, rewards_balance: 300)

      expect(employee_without_last_name.valid?).to be false
    end
  end

  describe "attributes" do
    it "should affirm that employee has exactly 6 attributes" do
      employee = Employee.new(first_name: "Jane", last_name: "Doe", rewards_balance: 400)

      expect(employee.attribute_names.map(&:to_sym)).to contain_exactly(
        :id,
        :first_name,
        :last_name,
        :rewards_balance,
        :created_at,
        :updated_at
      )
    end
  end

  describe "scopes" do
    describe ".zero_balance" do
      before do
        employees = Employee.create!([
          { first_name: "John", last_name: "Doe", rewards_balance: 0 },
          { first_name: "Jane", last_name: "Doe", rewards_balance: 400 },
          { first_name: "Jake", last_name: "Doe", rewards_balance: 0 }
        ])
      end
      it "should affirm that only 2 employees have a balance of zero" do
        employees_with_zero_balance = Employee.zero_balance
        balances = employees_with_zero_balance.map(&:rewards_balance)

        expect(employees_with_zero_balance.count).to be >= 2
        expect(balances).to all be <= 0
      end

      it "should affirm that it does not return all values in database" do
        all_employees = Employee.all
        employees_with_zero_balance = Employee.zero_balance

        expect(all_employees.count - employees_with_zero_balance.count).to be >= 1
      end
    end
  end

  describe "instance methods" do
    let(:employee) { Employee.new(first_name: "Jane", last_name: "Doe", rewards_balance: 400) }
    context ".full_name" do
      it "should return the full name of the employee" do 
        full_name = employee.full_name

        expect(full_name).to eq "Jane Doe"
      end
    end
    
    context ".can_afford" do
      it "should return true on reward_cost less than or equal to 400" do 
        less_than = employee.can_afford?(321)
        equal_to = employee.can_afford?(400)

        expect(less_than).to be true
        expect(equal_to).to be true
      end

      it "should return false on reward_cost greater than 400" do
        greater_than = employee.can_afford?(432)

        expect(greater_than).to equal false
      end
    end
  end

end
