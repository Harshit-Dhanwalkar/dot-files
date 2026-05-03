-- ~/.config/yazi/plugins/font-sample.yazi/main.lua

---@diagnostic disable: undefined-global

local M = {}

local set_config = ya.sync(function(st, opts)
	st.opts = opts
end)

local get_config = ya.sync(function(st)
	return st.opts
		or {
			text = "ABCDEF abcdef\n0123456789\noO08 iIlL1\nâéùïøçÃĒÆœ",
			canvas_size = "750x800",
			font_size = 80,
			fg = "black",
			bg = "white",
		}
end)

function M:setup(config)
	set_config(config)
end

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return
	end

	ya.sleep(math.max(0, 0.05 + start - os.clock()))
	ya.image_show(cache, job.area)
end

function M:seek() end

function M:preload(job)
	ya.err("DEBUG: Preload is running for " .. tostring(job.file.path))
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end
	local opts = get_config()

	local status, err = Command("/usr/bin/convert"):args({
		"-size",
		opts.canvas_size,
		"-background",
		opts.bg,
		"-fill",
		opts.fg,
		"-font",
		tostring(job.file.path),
		"-pointsize",
		tostring(opts.font_size),
		"-gravity",
		"center",
		"label:" .. opts.text,
		"PNG:" .. tostring(cache),
	}):status()

	if not status then
		return false, "Command failed: " .. tostring(err)
	end
	return status.success
end

return M
