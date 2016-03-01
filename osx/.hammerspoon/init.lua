local log = hs.logger.new('jmahs','debug')

local watcher = hs.fs.volume.new(function(eventType, relTable)
  if eventType == hs.fs.volume.didMount then
    if relTable.path == '/Users/jonathan/Files' then
      log.i('Files mounted')
      log.i('Starting dropbox...')
      local dropboxPid = hs.application.open('com.getdropbox.dropbox', 10):pid()
      if not dropboxPid then
        log.i('Could not find dropbox')
      end
      log.i('Starting ArqAgent...')
      local arqPid = hs.application.open('com.haystacksoftware.ArqAgent', 10):pid()
      if not arqPid then
        log.i('Could not find ArqAgent')
      end
    else
      log.i('Some other volume mounted: ' .. relTable.path)
    end
  elseif eventType == hs.fs.volume.willUnmount then
    log.i(relTable.path .. ' unmounting...')
    local dropboxPid = hs.application.get('com.getdropbox.dropbox'):pid()
    if dropboxPid then
      log.i('Killing dropbox pid ' .. dropboxPid .. ' first...')
      hs.application.get(dropboxPid):kill()
      dropboxPid = nil
     else
      log.i('No dropbox PID to kill')
    end
    local arqPid = hs.application.get('com.haystacksoftware.ArqAgent'):pid()
    if arqPid then
      log.i('Killing ArqAgent pid ' .. arqPid .. ' first...')
      hs.application.get(arqPid):kill()
      arqPid = nil
     else
      log.i('No ArqAgent PID to kill')
    end
  end
end):start()
