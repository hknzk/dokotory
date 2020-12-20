crumb :root do
  link "ホーム", root_path
end

crumb :login do
  link "ログイン", login_path
  parent :root
end

crumb :new_user do
  link "新規会員登録", new_user_path
  parent :root
end

crumb :articles do
  link "記事一覧", articles_path
  parent :root
end

crumb :article do |article|
  link article.name, article
  parent :articles
end

crumb :edit_article do |article|
  link "記事の編集", edit_article_path(article)
  parent :article, article
end

crumb :new_article do
  link '新規投稿', new_article_path
  parent :articles
end

crumb :map_articles do
  link 'マップで探す', map_articles_path
  parent :articles
end

crumb :visitor_article do
  link 'マップで探す', visitor_article_path
  parent :articles
end

crumb :user do |user|
  link "#{user.name}さんのページ", user
  parent :root
end

crumb :edit_user do |user|
  link "ログイン設定", edit_user_path(user)
  parent :user, user
end

crumb :edit_profile_user do |user|
  link "プロフィール編集", edit_profile_user_path(user)
  parent :user, user
end

crumb :posted_articles_user do |user|
  link "投稿した記事一覧", user
  parent :user, user
end

crumb :user_message do |message|
  link "メッセージ「#{message.name}」", user_message_path(message.receiver, message)
  parent :mypage_messages
end

crumb :new_user_message do |user|
  link "#{user.name}さんへのメッセージ作成", new_user_message_path(user)
  parent :user, user
end

crumb :mypage do
  link "マイページ", mypage_path
  parent :root
end

crumb :mypage_articles_in_progress do
  link "やりとり中の記事一覧", mypage_articles_in_progress_path
  parent :mypage
end

crumb :mypage_draft_articles do
  link "下書き中の記事一覧", mypage_draft_articles_path
  parent :mypage
end

crumb :mypage_favorites do
  link "お気に入りの記事一覧", mypage_favorites_path
  parent :mypage
end

crumb :mypage_received_messages do
  link "受け取ったメッセージ", mypage_received_messages_path
  parent :mypage
end

crumb :mypage_send_messages do
  link "送ったメッセージ", mypage_send_messages_path
  parent :mypage
end

crumb :mypage_posted_articles do
  link "投稿した記事一覧", mypage_posted_articles_path
  parent :mypage
end

crumb :mypage_notifications do
  link "通知一覧", mypage_notifications_path
  parent :mypage
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
