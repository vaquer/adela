json.designation_files @organization.designation_files do |designation_file|
  json.created_at designation_file.created_at
  json.download_url designation_file.file.url
  json.size designation_file.file.size
end

json.memo_files @organization.memo_files do |memo_file|
  json.created_at memo_file.created_at
  json.download_url memo_file.file.url
  json.size memo_file.file.size
end

json.ministry_memo_files @organization.ministry_memo_files do |ministry_memo_file|
  json.created_at ministry_memo_file.created_at
  json.download_url ministry_memo_file.file.url
  json.size ministry_memo_file.file.size
end
