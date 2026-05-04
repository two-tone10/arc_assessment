export default function handler(request, response) {
  response.status(200).json({
    supabaseUrl: process.env.SUPABASE_URL || "",
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY || "",
    aiInsightsEnabled: Boolean(process.env.OPENAI_API_KEY),
    storageMode: process.env.SUPABASE_URL && process.env.SUPABASE_ANON_KEY
      ? "supabase-ready"
      : "local-prototype"
  });
}
