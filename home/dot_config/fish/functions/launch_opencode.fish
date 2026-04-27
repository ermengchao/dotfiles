function launch_opencode
  set sessions (opencode session list --format json | jq -r '.[] | [.id, .title] | @tsv')

  if test (count $sessions) -eq 0
      opencode
  else
      set selected_session (printf '%s\n' $sessions | fzf --delimiter '\t' --with-nth=2.. --popup=80%,80%)

      if test -n "$selected_session"
          set session_id (string split -f1 \t -- "$selected_session")
          opencode -s "$session_id"
      end
  end

  if status is-interactive
      commandline -f repaint
  end
end
