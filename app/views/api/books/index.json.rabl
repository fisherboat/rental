object false
child(@books, object_root: false) {
  extends "api/books/detail"
}
node :pageination do
  {
    total_count: @books.total_count,
    total_pages: @books.total_pages,
    current_page: @books.current_page,
    next_page: @books.next_page,
    prev_page: @books.prev_page,
    is_first_page: @books.first_page?,
    is_last_page: @books.total_count > 0 ? @books.last_page? : true
  }
end