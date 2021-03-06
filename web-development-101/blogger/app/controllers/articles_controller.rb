class ArticlesController < ApplicationController

  before_action :require_login, except: [:index, :show]

  include ArticlesHelper

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find_by(id: params[:id])
    @article.increment!(:views)
    @popular = Article.order(views: :desc).limit(3)
    @comment = Comment.new
    @comment.article_id = @article.id

  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.save
    redirect_to @article
  end

  def edit
    @article = Article.find_by(id: params[:id])
  end

  def update
    @article = Article.find_by(id: params[:id])
    @article.update(article_params)
    flash.notice = "Article '#{@article.title}' Updated!"
    redirect_to @article
  end

  def destroy
    @article = Article.find(id: params[:id])
    @article.destroy
    redirect_to articles_path
  end

end
