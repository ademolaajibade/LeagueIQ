/* eslint-disable */
import * as Router from 'expo-router';

export * from 'expo-router';

declare module 'expo-router' {
  export namespace ExpoRouter {
    export interface __routes<T extends string | object = string> {
      hrefInputParams:
        | { pathname: Router.RelativePathString; params?: Router.UnknownInputParams }
        | { pathname: Router.ExternalPathString; params?: Router.UnknownInputParams }
        | { pathname: `/_sitemap`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}` | `/`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}/play` | `/play`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}/leaderboard` | `/leaderboard`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}/profile` | `/profile`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(auth)'}/login` | `/login`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(auth)'}/onboarding` | `/onboarding`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(auth)'}/register` | `/register`; params?: Router.UnknownInputParams }
        | { pathname: `/game/quiz`; params?: Router.UnknownInputParams }
        | { pathname: `/game/results`; params?: Router.UnknownInputParams }
        | { pathname: `/game/survival`; params?: Router.UnknownInputParams }
        | { pathname: `/match/lobby`; params?: Router.UnknownInputParams }
        | { pathname: `/match/[id]`; params: Router.UnknownInputParams & { id: string | number } }
        | { pathname: `/match/results`; params?: Router.UnknownInputParams };
      hrefOutputParams:
        | { pathname: Router.RelativePathString; params?: Router.UnknownOutputParams }
        | { pathname: Router.ExternalPathString; params?: Router.UnknownOutputParams }
        | { pathname: `/_sitemap`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(app)'}` | `/`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(app)'}/play` | `/play`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(app)'}/leaderboard` | `/leaderboard`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(app)'}/profile` | `/profile`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(auth)'}/login` | `/login`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(auth)'}/onboarding` | `/onboarding`; params?: Router.UnknownOutputParams }
        | { pathname: `${'/(auth)'}/register` | `/register`; params?: Router.UnknownOutputParams }
        | { pathname: `/game/quiz`; params?: Router.UnknownOutputParams }
        | { pathname: `/game/results`; params?: Router.UnknownOutputParams }
        | { pathname: `/game/survival`; params?: Router.UnknownOutputParams }
        | { pathname: `/match/lobby`; params?: Router.UnknownOutputParams }
        | { pathname: `/match/[id]`; params: Router.UnknownOutputParams & { id: string } }
        | { pathname: `/match/results`; params?: Router.UnknownOutputParams };
      href:
        | Router.RelativePathString
        | Router.ExternalPathString
        | `/_sitemap${`?${string}` | `#${string}` | ''}`
        | `${'/(app)'}${`?${string}` | `#${string}` | ''}`
        | `/${`?${string}` | `#${string}` | ''}`
        | `${'/(app)'}/play${`?${string}` | `#${string}` | ''}`
        | `/play${`?${string}` | `#${string}` | ''}`
        | `${'/(app)'}/leaderboard${`?${string}` | `#${string}` | ''}`
        | `/leaderboard${`?${string}` | `#${string}` | ''}`
        | `${'/(app)'}/profile${`?${string}` | `#${string}` | ''}`
        | `/profile${`?${string}` | `#${string}` | ''}`
        | `${'/(auth)'}/login${`?${string}` | `#${string}` | ''}`
        | `/login${`?${string}` | `#${string}` | ''}`
        | `${'/(auth)'}/onboarding${`?${string}` | `#${string}` | ''}`
        | `/onboarding${`?${string}` | `#${string}` | ''}`
        | `${'/(auth)'}/register${`?${string}` | `#${string}` | ''}`
        | `/register${`?${string}` | `#${string}` | ''}`
        | `/game/quiz${`?${string}` | `#${string}` | ''}`
        | `/game/results${`?${string}` | `#${string}` | ''}`
        | `/game/survival${`?${string}` | `#${string}` | ''}`
        | `/match/lobby${`?${string}` | `#${string}` | ''}`
        | `/match/${string}${`?${string}` | `#${string}` | ''}`
        | `/match/results${`?${string}` | `#${string}` | ''}`
        | { pathname: Router.RelativePathString; params?: Router.UnknownInputParams }
        | { pathname: Router.ExternalPathString; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}` | `/`; params?: Router.UnknownInputParams }
        | { pathname: `${'/(app)'}/play` | `/play`; params?: Router.UnknownInputParams }
        | { pathname: `/game/quiz`; params?: Router.UnknownInputParams }
        | { pathname: `/game/results`; params?: Router.UnknownInputParams }
        | { pathname: `/game/survival`; params?: Router.UnknownInputParams }
        | { pathname: `/match/lobby`; params?: Router.UnknownInputParams }
        | { pathname: `/match/[id]`; params: Router.UnknownInputParams & { id: string | number } }
        | { pathname: `/match/results`; params?: Router.UnknownInputParams };
    }
  }
}
