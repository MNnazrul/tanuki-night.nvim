import { InstanceFeatureFlagService } from './flags';
const COMMAND_ID = 'x';
export const activate = async (context: ExtensionContext) => {
  this.feedbackIcon = null;
  context.subscriptions.push(new InstanceFeatureFlagService(42));
};
