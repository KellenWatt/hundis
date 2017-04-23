INDEX_PAGE_SIZE = 10

class StaticPagesController < ApplicationController
  def users
    @pg_count = (User.count / INDEX_PAGE_SIZE).ceil
    @pg = (params["pg"] || 1).to_i

    if @pg < 1 or @pg > @pg_count
      raise "bad page number"
    else
      @users = User.limit(INDEX_PAGE_SIZE).offset(INDEX_PAGE_SIZE * (@pg - 1))
    end
  end
end
