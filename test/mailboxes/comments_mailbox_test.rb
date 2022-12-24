require "test_helper"

class CommentsMailboxTest < ActionMailbox::TestCase
  test "メール本文が、対応するBoardのコメントとして正しく追加されること" do
    board = Board.create
    user = User.create(email: "test@example.com")

    assert_difference -> { board.comments.count } do
      receive_inbound_email_from_mail \
        to: "#{board.id}-comment@example.com",
        from: user.email,
        subject: "メールタイトル",
        body: "こんにちは！"
    end
    comment = board.comments.last
    puts "============================"
    puts "comment"
    puts "============================"
    assert_equal user, comment.creator
    puts "============================"
    puts "============================"
    assert_equal "こんにちは！", comment.body
  end
end
