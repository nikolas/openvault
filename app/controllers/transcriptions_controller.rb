class TranscriptionsController < ApplicationController
	def create
		artifact = Artifact.find_or_create_by_pid_and_type(params[:pid], 'transcription')
		if artifact.request_digitization(current_user)
			flash[:notice] = 'request successfully made'
		else
		  flash[:error] = 'failure'
		end
    redirect_to request.referrer
	end

	def destroy
		artifact = current_user.artifacts.find(params[:pid])
		if artifact.withdraw_request(current_user)
			flash[:notice] = 'request withdrawn'
		else
		  flash[:error] = 'failure'
		end
		redirect_to user_root_path
	end
end
