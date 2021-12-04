class TakeawaysController < ApplicationController
  
  def index
    matching_takeaways = Takeaway.all

    @list_of_takeaways = matching_takeaways.order({ :created_at => :desc })

    render({ :template => "takeaways/index.html.erb" })
  end

  def user_takeaways
    
    matching_takeaways = @current_user.takeaways

    @list_of_takeaways = matching_takeaways.order({ :created_at => :desc })

    render({ :template => "takeaways/user_takeaways.html.erb" })
    
  end

  def show

    the_id = params.fetch("path_id")

    matching_takeaways = Takeaway.where({ :id => the_id })

    @the_takeaway = matching_takeaways.at(0)

    @the_article = Article.where(id: @the_takeaway.article_id).first

    render({ :template => "takeaways/show.html.erb" })

  end

  def create

    the_takeaway = Takeaway.new
    the_takeaway.body = params.fetch("query_body")
    the_takeaway.user_id = @current_user.id
    the_takeaway.article_id = params.fetch("query_article_id")
    the_takeaway.public = params.fetch("query_public", false)

    if the_takeaway.valid?
      the_takeaway.save
      redirect_to("/takeaways", { :notice => "Takeaway created successfully." })
    else
      redirect_to("/takeaways", { :notice => "Takeaway failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_takeaway = Takeaway.where({ :id => the_id }).at(0)

    the_takeaway.body = params.fetch("query_body")
    the_takeaway.user_id = params.fetch("query_user_id")
    the_takeaway.article_id = params.fetch("query_article_id")
    the_takeaway.public = params.fetch("query_public", false)

    if the_takeaway.valid?
      the_takeaway.save
      redirect_to("/takeaways/#{the_takeaway.id}", { :notice => "Takeaway updated successfully."} )
    else
      redirect_to("/takeaways/#{the_takeaway.id}", { :alert => "Takeaway failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_takeaway = Takeaway.where({ :id => the_id }).at(0)

    the_takeaway.destroy

    redirect_to("/takeaways", { :notice => "Takeaway deleted successfully."} )
  end
end