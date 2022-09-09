<% if author == current_user %>
  <form action="" method="post">
    <%= auth_token %>
    <input type="hidden" name="_method" value="delete">
    <input type="submit" value="Delete Post">
  </form>
<% end %>