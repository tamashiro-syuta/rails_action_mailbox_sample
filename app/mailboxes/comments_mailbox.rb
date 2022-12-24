class CommentsMailbox < ApplicationMailbox
  before_processing :validate_request

  def process
    board.comments.create!(body: mail.decoded, creator: commenter)
  end

  # リクエストのバリデーション
  def validate_request
    return if commenter && board

    # bounce_with --> ①CommentMailerオブジェクトに対して、deliver_laterメソッドでメールを送信して、②InBoundMailの状態をbounced(処理の実行をやめた状態)にする
    bounce_with CommentMailer.invalid_request(
      inbound_email, commenter: commenter, board: board
    )
  end

  # コメント投稿者となるUserオブジェクトを取得
  def commenter
    return @commenter if defined?(@commenter)
    @commenter = User.find_by(email: mail.from)
  end

  # 書き込み先Boardオブジェクトを取得
  def board
    return @board if defined?(@board)
    @board = Board.find_by(id: mail.to.split('-')[0])
  end
end
