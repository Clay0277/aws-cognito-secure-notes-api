exports.handler = async (event) => {
  // Extract userId from request (will integrate Cognito JWT later)
  const userId =
    event.requestContext?.authorizer?.jwt?.claims?.sub || "test-user";

  console.log("Authenticated request", { userId });

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Secure notes endpoint reached",
      userId,
    }),
  };
};
