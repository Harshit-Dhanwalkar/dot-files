-- ~/.config/yazi/plugins/preview-audio.yazi/main.lua

-- Only text
--[[
local M = {}

function M:peek(job)
	local output = Command("ffprobe"):arg({
		"-v",
		"quiet",
		"-show_entries",
		"stream_tags:format:stream",
		"-of",
		"default=noprint_wrappers=1",
		job.file.url,
	}):output()
	if not output then
		return
	end
	local lines = {}
	for line in output.stdout:gmatch("[^\r\n]+") do
		table.insert(lines, ui.Line(line))
	end
	ya.preview_widget(job, ui.Text(lines):area(job.area))
end

return M
]]

local M = {}

local audio_ffprobe = function(file)
	local cmd = Command("ffprobe"):arg({
		"-v",
		"quiet",
		"-show_entries",
		"stream_tags:format:stream",
		"-of",
		"json=c=1",
		file.name,
	})

	local output, err = cmd:output()
	if not output then
		return {}, Err("Failed `ffprobe`, error: %s", tostring(err))
	end

	-- local json = ya.json_decode(output.stdout)
	-- if not json then
	-- 	return nil, Err("Failed to decode `ffprobe` output: %s", output.stdout)
	-- elseif type(json) ~= "table" then
	-- 	return nil, Err("Invalid `ffprobe` output: %s", output.stdout)
	-- end
	-- -- ya.dbg(json)
	local json = ya.json_decode(output.stdout)
	if not json or type(json) ~= "table" then
		return { ui.Line("Failed to parse ffprobe output") }
	end

	local audio_stream = json.streams and json.streams[1] or {}
	local tags = json.format.tags or audio_stream.tags or audio_stream
	local duration = json.format.duration
	if duration then
		duration = tonumber(duration)
		duration = string.format("%d:%02d", math.floor(duration / 60), math.floor(duration % 60))
	else
		duration = "?"
	end

	local data = {}
	local title = tags.TITLE or tags.title or ""
	local album = tags.ALBUM or tags.album or ""
	local artist = tags.ARTIST or tags.artist or ""
	local aar = tags.ALBUM_ARTIST or tags.album_artist or ""

	-- local title, album, aar, ar =
	-- 	tags.TITLE or tags.title or "",
	-- 	tags.ALBUM or tags.album or "",
	-- 	tags.ALBUM_ARTIST or tags.album_artist or "",
	-- 	tags.ARTIST or tags.artist or ""
	--
	-- if title .. album .. ar .. aar ~= "" then
	-- 	local img_stream = json.streams[2]
	-- 	local date = tags.DATE or tags.date or ""
	-- 	local c = ""
	-- 	local artist = ar
	--
	-- 	if tags.ORIGINALDATE and tags.ORIGINALDATE ~= "" then
	-- 		date = date .. " / " .. tags.ORIGINALDATE
	-- 	end
	-- 	if (aar ~= "") and (aar ~= ar) then
	-- 		artist = artist .. " / " .. aar
	-- 	end
	-- 	if img_stream then
	-- 		c = img_stream.codec_name .. " " .. img_stream.width .. "x" .. img_stream.height
	-- 	end
	--
	-- 	data = {
	-- 		ui.Line(string.format("%s - %s", artist, title)),
	-- 		ui.Line(string.format("%s: %s", "Duration", duration)),
	-- 		ui.Line(string.format("%s: %s", "Album", album)),
	-- 		ui.Line(string.format("%s: %s", "Genre", tags.GENRE or tags.genre or "No genre")),
	-- 		ui.Line(string.format("%s: %s", "Date", date)),
	-- 		c ~= "" and ui.Line(string.format("%s: %s", "Cover art", c)) or nil,
	-- 	}
	-- end
	if title .. album .. artist .. aar ~= "" then
		local date = tags.DATE or tags.date or ""
		if tags.ORIGINALDATE and tags.ORIGINALDATE ~= "" then
			date = date .. " / " .. tags.ORIGINALDATE
		end
		local display_artist = artist
		if aar ~= "" and aar ~= artist then
			display_artist = artist .. " / " .. aar
		end

		data = {
			ui.Line(string.format("%s - %s", display_artist, title)),
			ui.Line(string.format("Duration: %s", duration)),
			ui.Line(string.format("Album: %s", album)),
			ui.Line(string.format("Genre: %s", tags.GENRE or tags.genre or "No genre")),
			ui.Line(string.format("Date: %s", date)),
		}
	end

	-- Technical specs
	local bd = audio_stream.bits_per_raw_sample or "1"
	local sr = audio_stream.sample_rate
	if sr then
		sr = string.format("%.1f kHz", sr / 1000)
	else
		sr = "?"
	end
	-- local br = tonumber((audio_stream.bit_rate or json.format.bit_rate or 0) // 1000) .. " kb/s"
	local br = tonumber((audio_stream.bit_rate or json.format.bit_rate or 0) // 1000) or 0
	local bitrate = br > 0 and (br .. " kb/s") or "?"
	local channels = audio_stream.channels or "?"
	local format = json.format.format_name or "?"

	-- for _, item in ipairs({
	-- 	"",
	-- 	"# Specs",
	-- 	string.format("%s: %s", "Format", json.format.format_name),
	-- 	string.format("%s: %sbit / %s", "Quality", bd, sr),
	-- 	string.format("%s: %s", "BitRate", br),
	-- 	string.format("%s: %s", "Channels", tostring(audio_stream.channels or "?")),
	-- }) do
	-- 	data[#data + 1] = ui.Line(item)
	-- end
	table.insert(data, ui.Line(""))
	table.insert(data, ui.Line("# Specs"))
	table.insert(data, ui.Line(string.format("Format: %s", format)))
	table.insert(data, ui.Line(string.format("Quality: %sbit / %s", bd, sr)))
	table.insert(data, ui.Line(string.format("BitRate: %s", bitrate)))
	table.insert(data, ui.Line(string.format("Channels: %s", channels)))

	return data
end

function M:peek(job)
	ya.notify({ title = "preview-audio", content = "peek called", level = "info", timeout = 1 })
	-- local start, cache = os.clock(), ya.file_cache(job)
	-- if not cache then
	-- 	return
	-- end
	local metadata = audio_ffprobe(job.file)
	ya.preview_widget(job, ui.Text(metadata):area(job.area))

	-- 	local err = self:preload(job)
	-- 	if err then
	-- 		ya.dbg(tostring(err)) -- TODO: fix random Failed to rename error
	-- 	end
	--
	-- 	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	-- 	local img_area, err = ya.image_show(cache, job.area)
	-- 	if err then
	-- 		-- ya.preview_widget(job, err) -- ignore because we have more stuff to print
	-- 		-- return
	-- 	end
	--
	-- 	local img_height = (img_area and img_area.h or 0)
	--
	-- 	ya.preview_widget(job, {
	-- 		ui.Text(audio_ffprobe(job.file)):area(ui.Rect({
	-- 			x = job.area.x,
	-- 			y = job.area.y + img_height,
	-- 			w = job.area.w,
	-- 			h = job.area.h - img_height,
	-- 		})),
	-- 	})
end

function M:seek() end

-- function M:preload(job)
-- 	local cache = ya.file_cache(job)
-- 	if not cache then
-- 		return
-- 	end
--
-- 	local cha = fs.cha(cache)
-- 	if cha and cha.len > 0 then
-- 		return
-- 	end
--
-- 	local output, err = Command("ffmpeg")
-- 		:arg({
-- 			"-hide_banner",
-- 			"-loglevel",
-- 			"warning",
-- 			"-i",
-- 			tostring(job.file.url),
-- 			"-frames:v",
-- 			"1",
-- 			"-an",
-- 			-- '-vcodec', 'copy',
-- 			string.format("%s.jpg", cache),
-- 		})
-- 		:stderr(Command.PIPED)
-- 		:output()
--
-- 	if not output then
-- 		return Err("Failed to start `ffmpeg`, error: %s", err)
-- 	elseif not output.status.success then
-- 		return Err("Failed to get image, stderr: %s", output.stderr)
-- 	end
--
-- 	local ok, err = fs.rename(Url(string.format("%s.jpg", cache)), cache)
-- 	if ok then
-- 		return
-- 	else
-- 		return Err("Failed to rename: %s", err)
-- 	end
-- end
function M:preload() end

return M
