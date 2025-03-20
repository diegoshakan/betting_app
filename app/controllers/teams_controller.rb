class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:index, :new, :create, :edit, :update] # Inclui edit e update
  before_action :set_team, only: [:edit, :update] # Configura o time para edit e update

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, notice: "Time criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @team já está configurado pelo set_team
  end

  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: "Time atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :division)
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end
end
