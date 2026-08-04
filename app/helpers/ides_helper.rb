# frozen_string_literal: true

module IdesHelper
  def default_ide_text_sketch
    "\
function draw() {
\tif (mouseIsPressed) {
\t\tfill(0);
\t} else {
\t\tfill(255);
\t}
\tellipse(mouseX, mouseY, 80, 80);
} // end draw()"
  end

  def default_ide_text_function
    "\
function setup() {
\tcreateCanvas(750, 500);
}"
  end

  def submit_button(course_lab_id)
    {
      text: "Resubmit",
      class: "btn-primary",
      no_further_query: false,
      post_url: ide_internal_send_code_url,
      split_action_url: ide_internal_split_pass_url,
      redirect_url: new_student_course_programming_lab_submission_from_ide_path(course_lab_id),
      new_window: false,
      params: { submit: true },
    }
  end

  def render_button
    {
      text: "Run Code",
      class: "btn-success",
      no_further_query: false,
      post_url: ide_internal_send_code_url,
      split_action_url: ide_internal_split_pass_url,
      redirect_url: player_url,
      new_window: true,
      params: {
        render: true,
        use_norandom_p5: use_norandom_p5, 
      },
    }
  end

  def use_norandom_p5
    if @verifier
      if @verifier.verify(params[:query])[:use_norandom_p5] == true
        return true
      end
    end

    return false
  end

  def download_button
    {
      text: "Download for Offline",
      class: "btn-info",
      no_further_query: true,
      post_url: ide_internal_send_code_url,
      split_action_url: ide_internal_split_pass_url,
      redirect_url: "",
      new_window: true,
      params: { download: true },
    }
  end

  def save_button(role)
    {
      text: role == "student" ? "Save Project" : "Save Changes",
      class: "btn-primary",
      no_further_query: false,
      post_url: ide_internal_send_code_url,
      split_action_url: ide_internal_split_pass_url,
      redirect_url: new_code_project_url,
      new_window: role == "student" ? true : false,
      params: { save: true, course_programming_lab_id: @course_programming_lab_id },
    }
  end

  def encoded_buttons(course_lab_id = nil, user = nil)
    [].tap do |buttons|
      buttons << render_button
      # We can tell the difference between the save case and the resubmit case based on 
      # whether the query param contains the "submission" parameter
      if @verifier
        decoded_query = @verifier.verify(params[:query])
        if decoded_query[:submission]
          buttons << submit_button(course_lab_id)
        else
          # If information about the associated programming lab is available, record it
          # so that we can auto-populate the project name field
          @course_programming_lab_id = decoded_query[:course_lab_id] # When creating a new project from the lab file group
          if !@course_programming_lab_id && @code_project
            @course_programming_lab_id = @code_project.course_programming_lab_id # When re-saving a project that was created from the lab instructions
          end
          if user.try(:teacher) || user.try(:super_teacher) || user.try(:admin)
            buttons << save_button("not_student")
          else
            buttons << save_button("student")
          end
        end
      else
        # If @verifier isn't even defined, default to the save case
        # i.e. for the sandbox
        if user.try(:teacher) || user.try(:super_teacher) || user.try(:admin)
          buttons << save_button("not_student")
        else
          buttons << save_button("student")
        end
      end
      buttons << download_button
    end.yield_self do |buttons|
      Base64.encode64(buttons.to_json)
    end
  end
end
