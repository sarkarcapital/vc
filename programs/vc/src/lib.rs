use anchor_lang::prelude::*;

declare_id!("C2wm61BsPG9k3nm1fzpeVAxyDhf7ok7ztgC9daNYW6t4");

#[program]
pub mod vc {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
