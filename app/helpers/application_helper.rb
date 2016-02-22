module ApplicationHelper
  def edit_and_destroy_buttons(item, back)
    back = link_to('Back', back, class: 'btn btn-default')
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]), class: 'btn btn-warning')
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class: 'btn btn-danger')
      raw("#{edit} #{del} #{back}")
    else
      raw("#{back}")
    end
  end

  def round(number)
    number_with_precision number, :precision => 1
  end
end