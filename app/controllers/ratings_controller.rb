class RatingsController < ApplicationController
  def index
    byebug
    ratings = Rating.all
    render json: ratings
  end

  def show
    rating = Rating.find(params[:id])
    render json: rating
  end

  def current_user
    # TODO: Implement current_user logic here
  end 

  def create

    # Find the booking
    booking = Booking.find_by(id: params[:booking_id])

    # Throw an error if the booking doesn't exist
    unless booking
      render json: { error: "Booking not found" }, status: :not_found
      return
    end

    # Create the rating with the provided parameters
    rating = Rating.new(
      booking_id: params[:booking_id],
      rating: params[:rating],
      review: params[:review]
    )

    if rating.save
      render json: { message: "Rating created successfully" }, status: :created
    else
      render json: { error: rating.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
  
  
  def update
    rating = Rating.find(params[:id])

    if rating.update(rating_params)
      render json: { message: "Rating updated successfully" }
    else
      render json: rating.errors, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.destroy

    render json: { message: "Rating deleted successfully" }, status: :ok
  end

  private

  def rating_params
    params.permit(:booking_id, :rating, :review)
  end
end
