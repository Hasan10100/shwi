const rateLimit = require("../config/upstash");

const rateLimiter = async (req,res,next) => {
    try {
        const {success} = await rateLimit.limit("limit-key");
        if (!success) {
            return res.status(429).json({message: "Too many requests"});
        }
        next();
    } catch (error) {
        console.log("Rate limit error", error);
    }
}

module.exports = rateLimiter;