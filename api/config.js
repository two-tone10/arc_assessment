export default function handler(request, response) {
  const supabaseUrl = (process.env.SUPABASE_URL || "").trim();
  const supabaseAnonKey = (process.env.SUPABASE_ANON_KEY || "").trim();
  const openAiKey = (process.env.OPENAI_API_KEY || "").trim();

  response.status(200).json({
    supabaseUrl,
    supabaseAnonKey,
    aiInsightsEnabled: Boolean(openAiKey),
    storageMode: supabaseUrl && supabaseAnonKey
      ? "supabase-ready"
      : "local-prototype"
  });
}
