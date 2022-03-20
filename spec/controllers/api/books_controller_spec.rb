require "rails_helper"

RSpec.describe Api::BooksController, type: :controller do
  describe "Book read" do
    let(:book) {create :book}
    it "#Index" do
      post :index, params: {format: :json}
      expect(response.status).to eq(200)
    end

    it "#Book detail" do
      get :show, params: { id: book.id, format: :json}
      expect(response.status).to eq(200)
    end
  end

  describe "Rental book" do
    let!(:book) {create :book, stock: 2}
    let!(:user) {create :user}
    context "#success" do
      it "#Borrrow" do
        post :borrow, params: { id: book.id, user_id: user.id, format: :json}
        expect(response.status).to eq(200)
      end

      it "#Repay" do
        create :rental_record, user: user, book: book, price: book.price, kind: "borrow"
        post :repay, params: { id: book.id, user_id: user.id, format: :json}
        expect(response.status).to eq(200)
      end
    end

    context "#Failure" do
      it "#Borrrow failure with no stock" do
        other_user = create :user
        create :rental_record, user: user, book: book, price: book.price, kind: "borrow"
        create :rental_record, user: other_user, book: book, price: book.price, kind: "borrow"
        post :borrow, params: { id: book.id, user_id: user.id, format: :json}
        data = JSON.parse(response.body)
        expect(response.status).to eq(422)
      end

      it "#Borrrow failure with balance" do
        other_user = create :user
        other_user.update(balance: book.price * 1.5)
        rental_record = build :rental_record, user: other_user, book: book, price: book.price, kind: "borrow"
        rental_record.run_borrow
        post :borrow, params: { id: book.id, user_id: other_user.id, format: :json}
        data = JSON.parse(response.body)
        expect(response.status).to eq(422)
      end
    end

  end

  describe "Inacome" do
    let!(:user) {create :user}
    let!(:book) {create :book}
    it "#actual" do
      create :rental_record, user: user, book: book, price: book.price, kind: "borrow"
      create :rental_record, user: user, book: book, price: book.price, kind: "repay"
      get :actual_income, params: { id: book.id, format: :json}
      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(data["amount"]).to eq(book.price.to_f)
    end
  end
end