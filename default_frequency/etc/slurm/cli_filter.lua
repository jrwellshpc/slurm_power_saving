-- Set --cpu-freq=high for sbatch/salloc/srun unless the user already set one.
-- Users can opt out with SLURM_NO_DEFAULT_CPUFREQ=1 or by passing --cpu-freq explicitly.

local function want_default(options)
  if os.getenv("SLURM_NO_DEFAULT_CPUFREQ") == "1" then
    return false
  end
  -- If user already supplied --cpu-freq (from CLI or #SBATCH), do nothing.
  return (options["cpu-freq"] == nil)
end

function slurm_cli_setup_defaults(options, early_pass)
  -- Called before env/CLI/#SBATCH are processed; perfect for site defaults.
  -- We’ll seed a default only on the “early” pass so user options can override later.
  if early_pass and want_default(options) then
    -- Set default for all three front-ends; srun inside an allocation skips this hook.
    options["cpu-freq"] = "high"
  end
  return slurm.SUCCESS
end

function slurm_cli_pre_submit(options, offset)
  -- After all options are parsed. If still no cpu-freq, set it here as a last resort.
  if want_default(options) then
    options["cpu-freq"] = "high"
  end
  -- Optional: log what we’re doing (shows up on the client side).
  slurm.log_info("cli_filter: enforcing --cpu-freq=high for %s", tostring(options["type"]))
  return slurm.SUCCESS
end

function init()  return slurm.SUCCESS end
function fini()  return slurm.SUCCESS end
function slurm_cli_post_submit(offset, jobid, stepid) return slurm.SUCCESS end
